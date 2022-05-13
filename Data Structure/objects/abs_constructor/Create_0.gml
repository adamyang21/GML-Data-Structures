//METHODS
function construct(arguments) {
    abstract_class();
}

function check_constructor_input(arguments, expected_argument_count) {
    if __type__(arguments) != "array" {
        throw("ValueError: arguments to constructor must be given as an array, received " + string(__type__(arguments)));
    }
    if __len__(arguments) < expected_argument_count {
        throw(string_literals("ValueError: missing argument(s) for %s constructor", [object_get_name(object_index)], "%s"));
    }
}

function get_attributes_names() {
    abstract();
}

function get_attributes() {
    abstract();
}