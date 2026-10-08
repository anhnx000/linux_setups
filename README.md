# SETUPS FOR LINUX/UBUNTU


## Quét secret (gitleaks)

Repo công khai, nên mỗi commit được quét bằng [gitleaks](https://github.com/gitleaks/gitleaks) qua hook trong `.githooks/`.

```bash
# Cài gitleaks (bản Linux x64, đổi phiên bản nếu cần)
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz \
  | tar -xz -C ~/.local/bin gitleaks

# Bật hook sau khi clone (mỗi máy chạy một lần)
git config core.hooksPath .githooks

# Quét toàn bộ lịch sử
gitleaks git --redact .
```

Không ghi đường dẫn, tên user, domain hay email thật vào repo. Dùng placeholder như `/path/to/folder`, `<user>`, `example.com`.
