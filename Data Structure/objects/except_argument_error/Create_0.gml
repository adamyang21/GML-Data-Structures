event_inherited();

//ATTRIBUTES
message = "";
function_name = "";
excepted_count = 0;
received_count = 0;



//CONSTRUCTOR
function constructor(arguments) {
    check_constructor_input(arguments, 2);
    with self {
        variable = arguments[0];
        expected_type = arguments[1];
        received_type = arguments[2];
    }
    message = string_literals("ArgumentError: expected {} arguments for {}, got {}", [expected_count, function_name, received_count]);
}

function raise_exception() {
    throw(message);
}