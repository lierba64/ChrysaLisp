(include 'gui/label/class.inc)

(def-class 'title 'label)
(dec-method 'vtable 'gui/title/vtable)
(dec-method 'create 'gui/title/create)
(dec-method 'init 'gui/title/init)

(dec-method 'mouse_down 'gui/title/mouse_down 'final)
(dec-method 'mouse_move 'gui/title/mouse_move 'final)

(def-struct 'title 'label)
	(int 'last_x)
	(int 'last_y)
(def-struct-end)
