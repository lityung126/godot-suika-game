extends Node

var bitmap_cache_dict = {}
var image_cache_dict = {}
var texture_cache_dict = {}

func get_texture(path : String) -> ImageTexture :
	if not texture_cache_dict.has(path):
		var image = get_image(path)
		if image == null :
			printerr("get texture fail because get_image null")
			return null;
		var t = ImageTexture.new()
		t.set_image(image)
		texture_cache_dict[path] = t
	return texture_cache_dict[path]

func get_image(path : String) -> Image :
	if not image_cache_dict.has(path):
		var image = Image.new()
		var err = image.load(path);
		if not err  == OK:
			printerr("cant find image")
			return null
		image_cache_dict[path] = image;
	return image_cache_dict[path]

func get_bitmap(path : String) -> BitMap:
	if not bitmap_cache_dict.has(path):
		var image = get_image(path)
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		bitmap_cache_dict[path] = bitmap
	return bitmap_cache_dict[path]
