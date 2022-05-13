function new() {
    if argument_count == 1 {
        value = argument[0];
        if typeof(value) == "number" {
            if value == floor(value)

        }
    }
}

function new_integer(value) {
    
}


function raise(_type, arguments) {
    if _type == Exception.Exception {
        var exception = instance_construct_depth(x, y, depth, except_exception, arguments);
    }
    else if _type == Exception.TypeError {
        var exception = instance_construct_depth(x, y, depth, except_type_error, arguments);
    }
    else if _type == Exception.ArgumentError {
        var exception = instance_construct_depth(x, y, depth, except_argument_error, arguments);
    }
    exception.raise_exception();
}