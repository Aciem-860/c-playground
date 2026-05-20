# C Playground (Emacs)

A small Emacs-based C development playground that automatically generates a fresh project environment with a `main.c` file and a `Makefile`.

Start a new project from everywhere using `M-x c-playground` function.

---

## 🚀 Features

- Automatically creates a new timestamped C project directory
- Generates:
  - `main.c` with a basic template
  - `Makefile` with common build rules
- Built-in compilation command (`make run`), this can be changed
- Quick switching between `main.c` and `Makefile`
- Minor mode with keybindings for faster workflow

---

## 📦 Project Structure

Each generated project looks like this:

```
c-playground-root/
└── DD-MMM-YYYY-HHhMMmSSs/
├── main.c
└── Makefile
```

Using `C-c b`, you can switch between `main.c` and the Makefile.

---

## ⚙️ Installation

1. Place `c-playground.el` in your Emacs load path, for example:

```
~/.emacs.d/local-packages/c-playground
```

Add this to your `init.el`:

```
(add-to-list 'load-path "~/.emacs.d/local-packages/")
(require 'c-playground)
```

Restart Emacs or evaluate your config.
