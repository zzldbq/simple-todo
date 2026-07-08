"""Simple Todo v2 登录/注册界面原型，不连接云端。"""

import tkinter as tk
from tkinter import messagebox


BG = "#F4F6FB"
CARD = "#FFFFFF"
TEXT = "#1F2937"
MUTED = "#6B7280"
BLUE = "#4F6BED"
BORDER = "#E5E7EB"


class AuthPreview:
    def __init__(self, window: tk.Tk) -> None:
        self.window = window
        self.window.title("简单待办 - 账号")
        self.window.geometry("920x720")
        # 登录卡片在注册模式下需要完整显示三组输入框和两个按钮。
        self.window.minsize(920, 720)
        self.window.configure(bg=BG)
        self.mode = "login"
        self._build()

    def _build(self) -> None:
        shell = tk.Frame(self.window, bg=BG)
        shell.pack(fill="both", expand=True, padx=70, pady=55)

        intro = tk.Frame(shell, bg=BLUE, width=340)
        intro.pack(side="left", fill="both")
        intro.pack_propagate(False)
        tk.Label(intro, text="✓", bg=BLUE, fg="white",
                 font=("Microsoft YaHei UI", 38, "bold")).pack(
                     anchor="w", padx=42, pady=(72, 18))
        tk.Label(intro, text="简单待办", bg=BLUE, fg="white",
                 font=("Microsoft YaHei UI", 26, "bold")).pack(
                     anchor="w", padx=42)
        tk.Label(intro, text="登录后，在电脑和手机上\n同步你的任务。",
                 bg=BLUE, fg="#E8ECFF", justify="left",
                 font=("Microsoft YaHei UI", 12),
                 pady=20).pack(anchor="w", padx=42)

        card = tk.Frame(shell, bg=CARD, padx=55, pady=45)
        card.pack(side="left", fill="both", expand=True)

        self.title_label = tk.Label(card, text="登录账号", bg=CARD, fg=TEXT,
                                    font=("Microsoft YaHei UI", 22, "bold"))
        self.title_label.pack(anchor="w")
        self.subtitle_label = tk.Label(
            card, text="欢迎回来，请输入账号信息。", bg=CARD, fg=MUTED,
            font=("Microsoft YaHei UI", 10), pady=8,
        )
        self.subtitle_label.pack(anchor="w", pady=(0, 22))

        tk.Label(card, text="邮箱", bg=CARD, fg=TEXT,
                 font=("Microsoft YaHei UI", 10, "bold")).pack(anchor="w")
        self.email_entry = self._entry(card)

        tk.Label(card, text="密码", bg=CARD, fg=TEXT,
                 font=("Microsoft YaHei UI", 10, "bold")).pack(anchor="w")
        self.password_entry = self._entry(card, show="•")

        self.confirm_label = tk.Label(card, text="确认密码", bg=CARD, fg=TEXT,
                                      font=("Microsoft YaHei UI", 10, "bold"))
        self.confirm_entry = self._entry(card, show="•", pack=False)

        self.submit_button = tk.Button(
            card, text="登录", command=self._submit_preview, bg=BLUE, fg="white",
            activebackground="#3F58D8", activeforeground="white", relief="flat",
            cursor="hand2", pady=11, font=("Microsoft YaHei UI", 10, "bold"),
        )
        self.submit_button.pack(fill="x", pady=(12, 12))

        self.switch_button = tk.Button(
            card, text="没有账号？创建账号", command=self._toggle_mode,
            bg=CARD, fg=BLUE, activebackground=CARD, activeforeground=BLUE,
            relief="flat", cursor="hand2", font=("Microsoft YaHei UI", 9),
        )
        self.switch_button.pack()

        tk.Label(card, text="当前是界面原型，尚未连接云端。", bg=CARD, fg=MUTED,
                 font=("Microsoft YaHei UI", 8)).pack(side="bottom")

    @staticmethod
    def _entry(parent: tk.Widget, show: str | None = None,
               pack: bool = True) -> tk.Entry:
        entry = tk.Entry(parent, show=show, bg="#FAFAFB", fg=TEXT,
                         relief="flat", highlightbackground=BORDER,
                         highlightthickness=1, font=("Microsoft YaHei UI", 11))
        if pack:
            entry.pack(fill="x", ipady=10, pady=(7, 18))
        return entry

    def _toggle_mode(self) -> None:
        self.mode = "register" if self.mode == "login" else "login"
        registering = self.mode == "register"
        self.title_label.configure(text="创建账号" if registering else "登录账号")
        self.subtitle_label.configure(
            text="注册后即可在多台设备同步任务。" if registering
            else "欢迎回来，请输入账号信息。"
        )
        self.submit_button.configure(text="注册" if registering else "登录")
        self.switch_button.configure(
            text="已有账号？返回登录" if registering else "没有账号？创建账号"
        )
        if registering:
            self.confirm_label.pack(anchor="w", before=self.submit_button)
            self.confirm_entry.pack(fill="x", ipady=10, pady=(7, 18),
                                    before=self.submit_button)
        else:
            self.confirm_label.pack_forget()
            self.confirm_entry.pack_forget()

    def _submit_preview(self) -> None:
        email = self.email_entry.get().strip()
        password = self.password_entry.get()
        if not email or not password:
            messagebox.showwarning("信息不完整", "请输入邮箱和密码。")
            return
        if self.mode == "register" and password != self.confirm_entry.get():
            messagebox.showwarning("密码不一致", "两次输入的密码不一致。")
            return
        messagebox.showinfo("原型提示", "界面验证通过；联网后再接入真实账号服务。")


def main() -> None:
    window = tk.Tk()
    AuthPreview(window)
    window.mainloop()


if __name__ == "__main__":
    main()
