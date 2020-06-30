extends MarginContainer
#A simple string splitter script that rapidly collects image links from the source of a Bpix album page.
#Written by The Flying Twybil

var entry_textedit : TextEdit
var result_textedit : TextEdit

var hyperlink_header : String = "https://bpix.lpbeach.co.uk/"

# Called when the node enters the scene tree for the first time.
func _ready():
	entry_textedit = get_node("VBoxContainer/txtentry/VBoxContainer/Entry")
	result_textedit = get_node("VBoxContainer/txtresult/VBoxContainer/Result")
	pass

#https://bpix.lpbeach.co.uk/_data/i/upload/2020/06/26/20200626211719-21a21aba-xs.jpg

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GatherButton_pressed():
	var text : String = entry_textedit.text
	
	if text and text != "":
		#This should separate the entire document into beginning with only the image source.
		#It starts with (__data) and continues from there.
		
		result_textedit.text = ""
		
		var first_split : Array = text.split('<img src="')
		
		first_split.pop_front()
		#We get rid of the first split because it's just nonsense information.
		
		var finished_splits : Array
		
		for split in first_split:
			#The easiest delimiter available is " thanks to the PHP formatting, which makes this nice and smooth.
			var newsplit = split.split('"')
			finished_splits.append(newsplit[0])
			#We only want the first element of the array, what should be our nicely divided image source.
			
		
		if finished_splits.size() > 0:
			var result_text : String
			
			for src in finished_splits:
				if src.begins_with("themes"):
					#The ajax loader gif will be picked up in the page's source. This causes
					#the program to properly ignore that.
					print("Ignoring ajax_loader.gif ...")
					pass
				else:
					var new_src : String = "[IMG]" + hyperlink_header + src + "[/IMG]" + "\n"
					result_text = result_text + new_src
					
			if result_text and result_text != "":
				
				var cleaning_split = result_text.rsplit("\n", true, 1)
				
				result_textedit.text = cleaning_split[0]
				#print("Everything went fine! Have a nice day!")
	pass


func _on_CopyButton_pressed():
	OS.clipboard = result_textedit.text
	pass
