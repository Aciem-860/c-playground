;;; c-playground.el --- Simple C playground -*- lexical-binding: t; -*-

;; Author: Pierre Ferru
;; Date: May 2026
;; Version: 0.1

;;; Commentary:
;; Generate a C project with a main.c and an attached Makefile in order
;; to test things or idea by running a simple Emacs command.

;;; Code:

(defvar c-template
  "// C-Playground Mode
// =================
// Keymaps
// -------
// * C-c C-c : compile the current project
// * C-b : switch between Makefile and main.c

#include <stdio.h>

int main(int argc, char** argv) {
    printf(\"Hello, world!\\n\");
    return 0;
}")

(defvar makefile-template
  "CC = gcc
CFLAGS = -g -O3

TARGET = main
SRC = main.c
OBJ = $(SRC:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

run: $(TARGET)
	./$(TARGET)")

(defcustom c-playground/root-directory
  "~/.emacs.d/c-playground"
  "Directory where all C projects are created")

(defun c-playground ()
  "Creates a temporary folder with template C main and Makefile"
  (interactive)

  (let* ((dir-name (format-time-string "%d-%b-%Y-%Hh%Mm%Ss"))
         (c-file-path (expand-file-name "main.c"
                               (expand-file-name dir-name
                                                  c-playground/root-directory)))
         (makefile-file-path (expand-file-name "Makefile"
                               (expand-file-name dir-name
                                                  c-playground/root-directory))))

    ;; create directory
    (make-directory (expand-file-name dir-name c-playground/root-directory) t)

    ;; create C file
    (with-temp-file c-file-path
      (insert c-template))

    ;; open Makefile buffer
    (let ((buf (find-file-noselect makefile-file-path)))
      (with-current-buffer buf
        (insert makefile-template)
        (c-playground-mode 1)
        (save-buffer)))
    
    ;; open C file
    (find-file c-file-path)

    ;; enable mode in current buffer
    (c-playground-mode 1)))

(defcustom c-playground/compile-command
  "make run"
  "Ran command when c-playground/compile-and-run is called")

(defun c-playground/compile-and-run ()
  "Compile and Run the program"
  (interactive)
  (compile c-playground/compile-command))

(defun c-playground/switch-buffer ()
  "Switch between C and Makefile buffers"
  (interactive)
  (let ((name (buffer-name)))
    (if (string-match "Makefile\\(<.*>\\)?" name) (find-file "main.c")
      (find-file "Makefile"))))

(define-minor-mode c-playground-mode
  "C Playground associated Minor Mode"
  :lighter " CPlayground"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-c") 'c-playground/compile-and-run)
            (define-key map (kbd "C-c b") 'c-playground/switch-buffer)
            map))

(provide 'c-playground)
