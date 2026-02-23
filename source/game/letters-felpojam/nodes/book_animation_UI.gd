@tool
extends AnimatedTextureRect
class_name AnimatedBookUI

signal enable_continue()

@export var pages: Array[Control]
@export var page_count : int = 5
@export var current_page : int = 0 # tracks the current page the book is displaying

# - set the book to be closed when the scene is loaded
func _ready() -> void:
	current_page = 0
	go_to_page(current_page)

# - Use this to always get a page number that is within the set page count
# - Cycles the number when a value outside the accepted range is provided
func clamp_current_page(new_page : int) -> int:
	# - negative values are interpreted as wanting to go to the last page
	if new_page < 0:
		new_page = page_count
	# - number greater than the page count are interpreted as wanting to go back to the first
	elif new_page > page_count:
		new_page = 0
	
	return new_page # return the updated number once in accepted range

# - Handles all the different conditions for playing a speciic animation on the book
# - Checks for invalid page values, and exits the method if it cannot go to the given page
# - When a valid page number is given, it first checks for all conditions where a unique animation is needed.
# - Unique animations are open book, close book, flip book, next / previous from first / last page
# - Correct unique animation played if matching criteria found
# - If no unqiue animation is needed, it plays a standard next or previous page animation
# - Which one it chooses is based on if the given number is higher or lower than the current page 
func go_to_page(page : int) -> void:
	if page == page_count:
		enable_continue.emit()

	# do nothing if already at the given page
	if current_page == page:
		return
	# do nothing if given a negative number or a number outside the page count
	if page < 0 or page > page_count:
		return

	# going to the first page - closed from front
	if page == 0:
		if current_page == page_count: # book closed from back
			play("closed_to_last") # go directly to closed front animation. As if flipping the book
		else:
			play("closed_to_first")

	# going to the last page - closed from back
	elif page == page_count:
			play("closed_to_last") # go directly to closed front animation. As if flipping the book

	# going to the first page
	elif page == 1: #todo: aqui
		if current_page == 0: # currently closed from front
			play("open_to_first") # open the book to the first page
		elif current_page == 2: # on the second page
			play("previous_page") # go back to the first page

	elif page == page_count - 1 && current_page == page_count:
		play("previous_from_last")

	# going to any middle page
	else:
		if page > current_page: # play next page if next page number is greater
			play("next_page")
		elif page < current_page: # play previous page if next page number is lesser
			play("previous_page")
	
	current_page = page # set current page to the new page

func _on_next_page_button_button_down() -> void:
	go_to_page(clamp_current_page(current_page + 1))

func _on_previous_page_button_button_down() -> void:
	go_to_page(clamp_current_page(current_page - 1))

func _on_close_button_button_down() -> void:
	go_to_page(clamp_current_page(0))

func _on_animation_finished() -> void:
	match current_page:
		1:
			show_page(1)
		2:
			show_page(2)
		3:
			show_page(3)
		4:
			show_page(4)
		_:
			_hide_all_pages()

func _hide_all_pages()-> void:	
	for page in pages:
		if page:
			page.visible = false

func show_page(number: int) -> void:
	var index := number - 1
	if index < 0 or index >= pages.size():
		push_warning("Número de página inválido: " + str(number))
		return
	
	for i in pages.size():
		pages[i].visible = (i == index)


func _on_animation_changed() -> void:
	_hide_all_pages()
