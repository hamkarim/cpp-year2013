; Пример программы hello, world

; Директива section начинает новую секцию. Секция это часть исполняемого файла.
; Существуют секции кода, данных, данных, доступных только для чтения, и т.п.
;      .text -- это имя секции, так обычно называют секцию куда попадает
;               исполняемый код (секция кода)
                section         .text

; Директива global _start делает символ _start видимым для линковщика
; Линковщик настраивает точку входа в программу так, чтобы она указывала на
; _start
                global          _start
_start:

; Коммадна syscall используется для передачи управления ядру операционной системы
;      номер системного вызова передается в регистре rax
;      аргументы передаются в регистрах rdi, rsi, edx, ecx, r8, r9
;      результат системного вызова возвращается в rax
;      инструкция syscall может испортить значение регистров rcx и r11

; 1 -- это номер системого вызова sys_write, его сигнатура:
; ssize_t sys_write(unsigned int fd, const char * buf, size_t count);
                mov             rax, 1
; Первый аргумент -- это номер файлового дескриптора, куда необходимо вывести данные
; обычно чтобы получить файловый дескриптор нужно вызвать функцию open(). Но
; существует три предопределенных файловых дескриптора:
;      0 -- stdin
;      1 -- stdout
;      2 -- stderr
                mov             rdi, 1
                mov             rsi, msg
                mov             rdx, msg_size
                syscall

; 60 -- это номер системного вызова sys_exit, его сигнатура:
; int sys_exit(int status);
; status -- это код, с которым с которым завершилась программа. Тот, кто запускал
; программу, может спросить с каким кодом она завершилась.
; По соглашению, 0 -- означает, что программа завершилась успешно, ненулевое
; значение означает, что в процессе работы программы произошла ошибка. Что означает
; то или иное значение кода возврата зависит от конкретной программы.
                mov             rax, 60
                xor             rdi, rdi
                syscall

; .rodata -- так обычно называют секцию, содержащую данные доступные только для
; чтения. Секция с данным доступными на запись обычно называется .data
                section         .rodata

; Директива db выводит последовательность байт. Байты перечисляются через запятую.
; Если передан строковый литерал, то выводятся байты соответствующие
; кодам символов этого литерала
; 0x0a -- это перевод строки (\n)
msg:            db              "Hello, world!",0x0a
; Директива 'a equ b' присваивает символу 'a' значение 'b'
; $ -- это псевдо-символ, означающий текущий адрес
msg_size:       equ             $ - msg
