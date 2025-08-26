class_name PSignal

var listeners: Array[Listener] = []

var canceled: bool

var stackMode: bool


func _init(stackMode: bool = false) -> void:
	self.stackMode = stackMode;


func add(listener: Listener) -> void:
	if listener not in listeners:
		if (stackMode):
			listeners.push_front( listener );
		else:
			listeners.push_back( listener );




func remove(listener: Listener) -> void:
	listeners.erase( listener );


func removeAll() -> void:
	listeners.clear();


func replace(listener: Listener) -> void:
	removeAll();
	add( listener );


func numListeners() -> int:
	return listeners.size();


func dispatch(t) -> void:

	#@SuppressWarnings("unchecked")
	var list: Array[Listener] = listeners

	canceled = false;
	for i: int in range(list.size()):

		var listener: Listener = list[i];

		if listener in listeners:
			listener.onSignal( t );
			if (canceled):
				return;

func cancel() -> void:
	canceled = true;
