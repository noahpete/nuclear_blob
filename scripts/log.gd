class_name Log

static func info(message: String) -> void:
	print("%s %s" % [_get_timestamp(), message])

static func _get_timestamp() -> String:
	var tick = Time.get_ticks_msec()
	var ms = str(tick)
	ms.erase(ms.length() - 1, 1)
	var timestamp = str(tick/3600000)+":"+str(tick/60000).pad_zeros(2)+":"+str(tick/1000).pad_zeros(2)+"."+ms+"\t"
	return timestamp
