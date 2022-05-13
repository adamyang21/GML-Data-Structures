event_inherited();

//ATTRIBUTES
data_structure = Data_Structure.Integer;
data_structure_print = "Integer";
value = 0;



//METHODS
//Override
function constructor() {
    check_constructor_input(arguments, 1);
    with self {
        value = arguments[0];
    }
    if typeof(value) != "number" {
        raise(Exception.TypeError, ["value", "number", typeof(value)]);
    }
    value = __to_integer();
}

//Override
function to_string() {
    return string(value);
}

function get() {
    return value;
}

function set(_value) {
    value = _value;
}



//PRIVATE METHODS
function __to_integer() {
    return floor(value);
}
