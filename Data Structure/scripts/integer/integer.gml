function Integer(_value): Object() constructor {
    //Attributes
    if typeof(_value) == "number" {
        value = floor(_value);
    }
    else {
        throw("TypeError: Integer constructor expected type number, got " + typeof(_value));
    }

    //Methods
    //Override
    function get() {
        return value;
    }

    //Override
    function copy() {
        return new Integer(value);
    }

    //Override
    function to_string() {
        return string(value);
    }
}
