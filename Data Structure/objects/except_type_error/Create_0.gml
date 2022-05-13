event_inherited();

//ATTRIBUTES
message = "";
variable = "";
expected_type = "";
received_type = "";



//CONSTRUCTOR
function constructor(arguments) {
    check_constructor_input(arguments, 2);
    with self {
        variable = arguments[0];
        expected_type = arguments[1];
        received_type = arguments[2];
    }
    message = string_literals("TypeError: expected {} type for {}, got {}", [expected_type, variable, received_type]);
}

function raise_exception() {
    throw(message);
}