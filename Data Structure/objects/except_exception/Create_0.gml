event_inherited();

//ATTRIBUTES
message = "";



//CONSTRUCTOR
function constructor(arguments) {
    check_constructor_input(arguments, 0);
    with self {
        if arguments == 1 {
            message = "Exception: " + string(arguments[0]);
        }
        else {
            message = "Exception";
        }
    }
}

function raise_exception() {
    throw(message);
}