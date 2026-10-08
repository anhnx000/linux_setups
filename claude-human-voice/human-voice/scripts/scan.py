#!/usr/bin/env python3
"""Quét nhanh dấu hiệu văn AI bề mặt (từ ngữ, dấu câu, định dạng) trong văn bản Việt/Anh.

Dùng: python3 -I scan.py FILE      hoặc      cat FILE | python3 -I scan.py
Chỉ bắt dấu hiệu bề mặt. Cấu trúc (bộ ba, câu chốt, sai người đọc) phải tự đọc.
"""
import re
import sys

PATTERNS = {
    "lời chatbot": [
        r"chắc chắn rồi", r"tất nhiên rồi", r"câu hỏi (rất )?hay", r"hoàn toàn đúng",
        r"hy vọng (điều|thông tin) này", r"đừng ngần ngại", r"bạn có muốn tôi",
        r"dưới đây là", r"\bcertainly!", r"\bof course!", r"great question",
        r"you'?re absolutely right", r"i hope this helps", r"let me know if",
        r"as an ai language model", r"here is an? ",
    ],
    "câu dẫn": [
        r"hãy cùng (tìm hiểu|khám phá)", r"nói thẳng ra", r"thành thật mà nói\?",
        r"ít ai (biết|dám nói)", r"không ai nói", r"let'?s dive in", r"here'?s the thing",
        r"here'?s what you need to know", r"without further ado",
    ],
    "đối lập giả": [
        r"không (chỉ|đơn thuần|phải)\b.{0,80}?\bmà (còn|là)", r"chứ không phải",
        r"\bnot (just|only|merely)\b.{0,80}?\bbut\b", r"\bit'?s not\b.{0,60}?\bit'?s\b",
    ],
    "tổng kết rỗng": [
        r"^\s*(tóm lại|nhìn chung|nói tóm lại|kết luận lại)", r"\bin conclusion\b",
        r"\bto sum up\b", r"\bin summary\b",
    ],
    "thổi phồng": [
        r"đóng vai trò (quan trọng|then chốt|chủ chốt)", r"không thể phủ nhận",
        r"minh chứng", r"bước ngoặt", r"dấu ấn sâu đậm", r"kỷ nguyên mới",
        r"tương lai đầy hứa hẹn", r"khẳng định vị thế", r"hơn bao giờ hết",
        r"stands? as a testament", r"pivotal moment", r"the future looks bright",
        r"plays? a (key|crucial|pivotal) role",
    ],
    "từ vựng AI (vi)": [
        r"bức tranh (toàn cảnh)?", r"hành trình", r"\bkhám phá\b", r"nâng tầm",
        r"một cách (hiệu quả|toàn diện|bền vững)", r"đáng chú ý là", r"^\s*bên cạnh đó",
        r"^\s*ngoài ra", r"trong bối cảnh hiện nay", r"thời đại (số|4\.0)", r"kỷ nguyên số",
        r"không ngừng thay đổi", r"điều quan trọng cần lưu ý", r"mang lại giá trị",
        r"góp phần thúc đẩy", r"đa dạng và phong phú",
    ],
    "từ vựng AI (en)": [
        r"\badditionally\b", r"\balign(s|ed)? with\b", r"\bboasts?\b", r"\bbolstered\b",
        r"\bcrucial\b", r"\bdeep dive\b", r"\bdelve", r"\benduring\b", r"\benhanc",
        r"\bfoster", r"\bgarner", r"\bhighlight(s|ed|ing)?\b", r"\binterplay\b",
        r"\bintricat", r"\blandscape\b", r"\bleverag", r"\bmeticulous", r"\bmultifaceted\b",
        r"\bnavigat(e|ing) the", r"\bpivotal\b", r"\brobust\b", r"\bseamless", r"\bshowcas",
        r"\btapestry\b", r"\btestament\b", r"\bunderscor", r"\bvibrant\b",
        r"today'?s fast-paced", r"it'?s important to note", r"ever-evolving",
    ],
    "quảng cáo": [
        r"nằm giữa lòng", r"vị trí đắc địa", r"ngỡ ngàng", r"không thể bỏ qua", r"đẳng cấp",
        r"\bnestled\b", r"\bbreathtaking\b", r"\bmust-visit\b", r"\brenowned\b",
    ],
    "uy tín mơ hồ": [
        r"các chuyên gia (cho rằng|nhận định)", r"nhiều nghiên cứu (chỉ ra|cho thấy)",
        r"giới quan sát", r"experts (believe|argue|say)", r"industry reports",
    ],
    "né là/có": [
        r"đóng vai trò là", r"tự hào (có|sở hữu)", r"\bserves as\b", r"\bstands as\b",
    ],
    "giới hạn kiến thức": [
        r"tính đến thời điểm (cập nhật|huấn luyện)", r"dựa trên thông tin hiện có",
        r"as of my (last|knowledge)", r"based on available information",
    ],
    "dấu vết công cụ": [
        r"contentReference", r"oaicite", r"turn0search\d", r"\[cite: ?\d+\]", r":::writing",
    ],
}

DASH = re.compile(r"[—–]| -- ")
CURLY = re.compile(r"[“”‘’]")
BOLD_LABEL = re.compile(r"^\s*([-*+]|\d+\.)\s+(\S+\s+)?\*\*[^*]+:?\*\*:?")
EMOJI = re.compile(r"[\U0001F300-\U0001FAFF✅✨➡→]")
FENCE = re.compile(r"^\s*```")


def scan(text):
    hits = {}
    in_code = False
    lines = text.splitlines()
    for no, line in enumerate(lines, 1):
        if FENCE.match(line):
            in_code = not in_code
            continue
        if in_code:
            continue
        prose = re.sub(r"`[^`]*`|https?://\S+", "", line)
        low = prose.lower()
        for group, pats in PATTERNS.items():
            for p in pats:
                for m in re.finditer(p, low, re.MULTILINE):
                    hits.setdefault(group, []).append((no, m.group(0).strip()))
        for name, rx in (("gạch ngang dài", DASH), ("ngoặc cong", CURLY),
                         ("emoji/mũi tên", EMOJI)):
            n = len(rx.findall(prose))
            if n:
                hits.setdefault(name, []).append((no, f"x{n}"))
        if BOLD_LABEL.match(prose):
            hits.setdefault("nhãn in đậm", []).append((no, prose.strip()[:40]))
    return hits, len(lines)


def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1], encoding="utf-8") as f:
            text = f.read()
    else:
        text = sys.stdin.read()
    hits, total = scan(text)
    if not hits:
        print("Không thấy dấu hiệu bề mặt. Vẫn cần tự đọc phần cấu trúc.")
        return
    count = sum(len(v) for v in hits.values())
    print(f"{count} dấu hiệu trong {total} dòng:\n")
    for group, items in sorted(hits.items(), key=lambda kv: -len(kv[1])):
        print(f"[{group}] {len(items)}")
        for no, s in items[:12]:
            print(f"  dòng {no}: {s}")
        if len(items) > 12:
            print(f"  ... và {len(items) - 12} chỗ khác")
    print("\nMột dấu hiệu đơn lẻ chưa nói lên gì. Nhiều nhóm cùng lúc mới đáng sửa.")


if __name__ == "__main__":
    main()
