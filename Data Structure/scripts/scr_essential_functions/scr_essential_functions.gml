/*
Add/Implement the following functions:
- range()
- array_get_largest_column_index()
- convert_ds_list_array()
- convert_ds_queue_array()
- convert_ds_stack_array()
- convert_ds_grid_array()
- convert_ds_map_array()
- convert_ds_priority_array()
- pass()
*/

/// @function __type__(object: T) -> string
/// @description Returns the type of the object. This supports data structures (ds), which typeof() does not.
/// @param object is the object to check the type of.
/// @return type of object as string.
function __type__(object) {
    var type_array = ["string", "array", "bool", "int32", "int64", "ptr", "undefined", "null", "vec3", "vec4", "unknown"];
    var ds_array = [ds_type_map, ds_type_list, ds_type_stack, ds_type_grid, ds_type_queue, ds_type_priority]

    var i;
    for (i = 0; i < array_length_1d(type_array); i++) {
        if typeof(object) == type_array[i] {
            return type_array[i]
        }
    }

    for (i = 0; i < array_length_1d(ds_array); i++) {
        if ds_exists(object, ds_array[i]) {
            if ds_array[i] == ds_type_list {return "ds_list";}
            else if ds_array[i] == ds_type_stack {return "ds_stack";}
            else if ds_array[i] == ds_type_queue {return "ds_queue";}
            else if ds_array[i] == ds_type_grid {return "ds_grid";}
            else if ds_array[i] == ds_type_map {return "ds_map";}
            else if ds_array[i] == ds_type_priority {return "ds_priority";}
        }
    }

    if typeof(object) == "number" {
        return "number";
    }
}



/// @function __len__(object: T) -> number
/// @description takes the argument and returns the length of the object.
/// @param object is the object to check the length of.
/// @return the length of the object.
function __len__(object) {
    var object_type = __type__(object);

    if object_type == "array" {return array_length_1d(object);}
    else if object_type == "string" {return string_length(object);}
    else if object_type == "ds_map" {return ds_map_size(object);}
    else if object_type == "ds_list" {return ds_list_size(object);}
    else if object_type == "ds_stack" {return ds_stack_size(object);}
    else if object_type == "ds_grid" {return [ds_grid_width(object), ds_grid_height(object)];}
    else if object_type == "ds_queue" {return ds_queue_size(object);}
    else if __type__(object) == "ds_priority" {return ds_priority_size(object);}
    else {throw("TypeError: len does not support type "+string(object_type));}
}



/// @function __linear_search(object: T, element: T) -> bool
/// @description performs linear search on an iterable object and returns if the given element is in the object (O(n) time complexity).
/// @param object is the object to be searched.
/// @param element is the element to be found.
/// @return whether the element is in the object or not.
function __linear_search(object, element) {
    if __type__(object) == "string" && __type__(element) == "string" {
        var i;
        for (i = 0; i < __len__(object)-__len__(element)+1; i++) {
            if string_char_at(object, i) == string_char_at(element, 0) {
                var j = 1;
                var is_substring = true;
                while j < __len__(element) {
                    if string_char_at(object,i+j) != string_char_at(element,j) {
                        is_substring = false;
                        break;
                    }
                    j++;
                }
                if is_substring {
                    return true;
                }
            }
        }
    }

    else {
        var i;
        for (i = 0; i < __len__(object); i++) {
            if object[i] == element {
                return true;
            }
        }
    }

    return false;
}



/// @function __binary_search(array: array, element: T) -> bool
/// @description performs binary search on a sorted array and returns if the given element is in the object.
/// @param array is the array to be searched.
/// @param element is the element to be found.
/// @return whether the element is in the array or not.
function __binary_search(array, element) {
    var lower_bound = 0;
    var upper_bound = __len__(array)-1;
    var mid_point;

    while lower_bound <= upper_bound {
        mid_point = floor((lower_bound + upper_bound)/2);
        if array[mid_point] > element {
            upper_bound = mid_point - 1;
        }
        else if array[mid_point] < element {
            lower_bound = mid_point + 1;
        }
        else {
            return true;
        }
    }
    return false;
}



/// @function __contains__(object: T, element: T, sorted = false: bool) -> bool
/// @description checks if the given element exists in the given iterable object.
/// @param object is an iterable object to be checked over.
/// @param element is the element to be found in the object.
/// @param sorted specifies whether the object is sorted or not (to use binary search or not).
/// @return whether the object contains the element or not.
function __contains__(object, element, sorted = false) {
    var object_type = __type__(object);

    if sorted {
        if object_type == "array" {
            return __binary_search(object,element);
        }
        else {
            throw("TypeError: For sorted, the given object must be an array.");
        }
    }
    else {
        if __type__(object) == "ds_map" {
            return ds_map_exists(object,element);
        }
        else if __type__(object) == "ds_list" {
            var index = ds_list_find_index(object,element);
            if index == -1 {
                return false;
            }
            else {
                return true;
            }
        }
        else {
            return __linear_search(object,element);
        }
    }
}



/// @function __getitem__(object: T, index: T) -> T
/// @description gets the item at the index in an iterable object.
/// @param object is an iterable object that contains the index.
/// @param index is the index of the iterable. The type is either a number or an array, depending on the object.
/// @return the item in the object at the provided index.
function __getitem__(object, index) {
    object_type = __type__(object);
    index_type = typeof(index);
    
    //Array
    if object_type == "array" {
        if index_type == "number" {
            var index_item = object[index];
            if typeof(index_item) == "array" {
                throw("ValueError: for number indexes, the array must be one-dimensional.");
            }
            else {
                return index_item;
            }
        }
        else if index_type == "array" {
            var res;
            var subarray = object[index[0]];
            var i;
            for (i = 1; i < __len__(index)-1; i++) {
                subarray = subarray[index[i]];
            }
            res = subarray[index[__len__(index)-1]];
            if typeof(res) == "array" {
                throw("ValueError: incorrect number of coordinates given for array depth.");
            }
            else {
                return res;
            }
        }
    }

    //Iterable string
    else if object_type == "string" {
        if index_type == "array" {
            throw("TypeError: index must be a number for string object.");
        }
        else if index_type == "number" {
            return string_char_at(object,index+1);
        }
    }

    //ds_list
    else if object_type == "ds_list" {
        if index_type == "array" {
            throw("TypeError: index must be a number for ds_list object.");
        }
        else if index_type == "number" {
            return ds_list_find_value(object,index);
        }
    }

    //ds_grid
    else if object_type == "ds_grid" {
        if index_type == "number" {
            throw("TypeError: index must be an array for ds_grid object.");
        }
        else if index_type == "array" {
            index_length = len(index);
            if index_length != 2 {
                error_message("expected index length 2, got "+string(index_length),"ValueError");
                throw("ValueError: index array length must be 2 for getting values in ds_grid object.");
            }
            else {
                return ds_grid_get(object,index[0],index[1]);
            }
        }
    }

    //ds_map
    else if object_type == "ds_map" {
        return ds_map_find_value(object,index);
    }

    //else
    else {
        throw("TypeError: __getitem__ does not support type " + object_type);
    }
}



/// @function __delitem__(object: T, index: T) -> T
/// @description deletes an item from an iterable object.
/// @param object is the object to delete an item from.
/// @param index is the index of which to delete from.
/// @return the object with the item at index deleted.
function __delitem__(object, index) {
    object_type = __type__(object);
    index_type = typeof(index);

    //Array
    if object_type == "array" {
        array_delete(object, index, 1);
        return object;
    }

    //Iterable string
    else if object_type == "string" {
        var res = "";
        var i;
        for (i = 0; i < __len__(object); i++) {
            if i != index {
                res += __getitem__(object, i);
            }
        }
        return res;
    }

    //ds_list
    else if object_type == "ds_list" {
        ds_list_delete(object, index);
        return object;
    }
    
    //ds_map
    else if object_type == "ds_map" {
        ds_map_delete(object, index);
        return object;
    }

    //else
    else {
        throw("TypeError: __delitem__ does not support type " + object_type);
    }
}



/// @function array_concatenation(array1: array, array2: array) -> array
/// @description concatenates the given arrays and returns the result.
/// @param array1 is the first array.
/// @param array2 is the second array.
/// @return the two arrays concatenated.
function array_concatenation(array1, array2) {
    var res = [];
    var i;
    for (i = 0; i < __len__(array1); i++) {
        array_push(res, array1[i])
    }
    for (i = 0; i < __len__(array2); i++) {
        array_push(res, array2[i])
    }
    return res;
}



/// @function array_augmented_concatenation(array1: array, array2: array) -> array
/// @description concatenates the given arrays using augmented concatenation.
/// @description in Python this would be: array1 += array2.
/// @param array1 is the first array.
/// @param array2 is the second array.
/// @return the two arrays concatenated.
function array_augmented_concatenation(array1, array2) {
    var i;
    for (i = 0; i < __len__(array2); i++) {
        array_push(array1, array2[i]);
    }
    return array1;
}



/// @function basic_array_slice(array: array, left: number, right: number) -> array
/// @description returns a section of a 1D array bound by left and right.
/// @param array is the array for be sliced.
/// @param left is the left bound index for slicing.
/// @param right is the right bound index for slicing.
/// @return the section of the given 1D sliced between left and right.
function basic_array_slice(array, left, right) {
    var res;

    var i;
    var j = 0;
    for (i = left; i < right; i++) {
        res[j] = array[i];
        j++;
    }

    return res;
}



/// @function array_constant(length: int, value: T) -> array
/// @description creates an array of given length filled with a given constant.
/// @description basically in Python: [value]*length.
/// @param length is the length of array.
/// @param value is the constant value to fill the array with.
/// @return the array of length with constant value.
function array_constant(length, value) {
    var res = [];
    var i;
    for (i = 0; i < length; i++) {
        array_push(res, value);
    }
    return res;
}



/// @function string_split(str: string, delimiter: string) -> array
/// @description produces an array with components of the given string split based on the given delimiter.
/// @param string is the string to be split.
/// @param delimiter is the string representing where to split the string.
/// @return an array with the split string substrings.
function string_split(str, delimiter) {
	var i = 0;
    var j = 0;
    var k = 0;
    var res; //return result
    var substring = ""; //substring (post-split)
    var is_delimiter;

    while i < __len__(str) {
        if __getitem__(str,i) == __getitem__(delimiter,0) {
            is_delimiter = true;
            if !(i == __len__(str)-1 && __len__(delimiter) > 1) {
                for (j = 0; j < __len__(delimiter); j++) {
                    if __getitem__(str,i+j) != __getitem__(delimiter,j) {
                        is_delimiter = false;
                        break;
                    }
                }
                if is_delimiter {
                    res[k] = substring;
                    k++;
                    substring = "";
                    if i == __len__(str)-__len__(delimiter) {
                        res[k] = "";
                        k++;
                    }
                    i += __len__(delimiter)-1;
                }
                else {
                    substring += __getitem__(str,i);
                    if i == __len__(str)-1 {
                        res[k] = substring;
                        k++;
                    }
                }
            }
        }
        else {
            substring += __getitem__(str,i);
            if i == __len__(str)-1 {
                res[k] = substring;
                k++;
            }
        }
        i++;
    }

    return res;
}



/// @functions string_literals(str: string, values: array, symbol: string) -> string
/// @description replaces placeholders within a string with values given in an array.
/// @param str is the string to be formatted.
/// @param values is an array containing values to replace with.
/// @param symbol is the symbolic placeholder to replace.
/// @return string with placeholders replaced with values.
function string_literals(str, values, symbol) {
    if argument_count != 3 {
        throw("ValueError: incorrect number of arguments given for string_literals");
    }
    
    var res = "";
    var i = 0;

    //Generate list of substrings
    var string_list = string_split(str,symbol);

    //Check if number of symbols matches with number of values
    if __len__(values) != __len__(string_list)-1 {
        throw("ValueError: incorrect number of values for replacement");
    }

    //Iterate and produce new string
    while i < __len__(string_list)-1 {
        res += string_list[i];
        res += string(values[i]);
        i++;
    }
    res += string_list[__len__(string_list)-1];

    return res;
}



/// @function string_slice(str: string, string_range: array) -> string
/// @description slices the string and returns the substring between the range specified.
/// @param str is the string to slice.
/// @param string_range is the range to slice the string between.
/// @return the portion of the string between the specified ranges.
function string_slice(str, string_range) {
    var start = str_range[0];
    var end_val = str_range[1];
    var res = "";

    var i;
    for (i = start; i < end_val; i++) {
        res += __getitem__(str,i);
    }

    return res;
}



/// @function pass() -> None
/// @description does nothing, or prints into console; acts the same as the pass keyword in Python, plus the printing for reminders.
function pass(message) {
    if typeof(message) != "undefined" {
        show_debug_message(message);
    }
    else {
        //DO NOTHING
    }
}




/// @function instance_create_single_depth(x: number, y: number, depth: number, object: object) -> instance
/// @description creates an instance of a given object if an instance does not already exist.
/// @param x is the x-coordinate.
/// @param y is the y-coordinate.
/// @param depth is the depth of the instance.
/// @param object is the object to create.
/// @return ID of the created instance. 
function instance_create_single_depth(_x, _y, _depth, object) {
    var instance = -1;
    
    if !instance_exists(object) {
        instance = instance_create_depth(_x, _y, _depth, object);
    }

    return instance;
}



/// @function instance_construct_depth(x: number, y: number, depth: number, object: object, arguments: array) -> instance
/// @description creates and constructs an instance of a given object using the object's constructor.
/// @param x is the x-coordinate.
/// @param y is the y-coordinates.
/// @param depth is the depth of the instance.
/// @param object is the object to create.
/// @param arguments is an array of arguments to be provided to the constructor.
/// @return ID of the created instance.
function instance_construct_depth(_x, _y, _depth, object, arguments) {
    var instance = instance_create_depth(_x, _y, _depth, object);
    instance.construct(arguments);
    return instance;
}



/// @function instance_construct_single_depth(x: number, y: number, depth: number, object: object, arguments: array) -> instance
/// @description creates and constructs an instance of a given object using the object's constructor if an instance does not already exist..
/// @param x is the x-coordinate.
/// @param y is the y-coordinates.
/// @param depth is the depth of the instance.
/// @param object is the object to create.
/// @param arguments is an array of arguments to be provided to the constructor.
/// @return ID of the created instance.
function instance_construct_single_depth(_x, _y, _depth, object, arguments) {
    var instance = instance_create_single_depth(_x, _y, _depth, object);
    instance.construct(arguments);
    return instance;
}



/// @function unclip(directions: number, collision: object) -> number
/// @description unclips the player from within collision blocks based on the number of directions given.
/// @param directions is the number of directions to check.
/// @param collision is the collision object.
/// @return the length.
//(Based on a Youtube video I watched for fixing clipping issues. UPDATE THIS WHEN VIDEO FOUND.)
function unclip(directions, collision) {
    var DEGREES = 360;
    var dir = 0;
    var length = 1;
    var x_val = x;
    var y_val = y;

    while place_meeting(x, y, collision) {
        x = x_val;
        y = y_val;
        
        x += lengthdir_x(length,dir);
        y += lengthdir_y(length,dir);
        
        dir += DEGREES/directions;
        if (dir >= DEGREES)
        {
            dir -= DEGREES;
            length += 1;
        }
    }

    return length;
}



/// @function get_sprite_centre_x()
/// @description calculates the x-centre of the sprite.
/// @return the x-centre of the sprite.
function get_sprite_centre_x() {
    return x + sprite_width/2;
}



/// @function get_sprite_centre_y()
/// @description calculates the y-centre of the sprite.
/// @return the y-centre of the sprite.
function get_sprite_centre_y() {
    return y + sprite_height/2;
}



/// @function get_single_instance(object: object) -> instance
/// @description returns the reference to the instance of a single object.
/// @param object is the single object to find the instance of.
/// @return the reference to the instance.
function get_single_instance(object) {
    return instance_find(object, 0);
}



/// @function abstract()
/// @description declares a given method (function) as abstract and thus cannot be called.
/// @description if this function is called, it means the method has not been implemented/overridden in its child classes.
function abstract() {
    throw("AbstractMethodCallError: this method is declared as an abstract method and has not been implemented/overridden.");
}



/// @function abstract_class()
/// @description declares a given class (object) as abstract and thus cannot be instantiated via a constructor.
/// @description if this function is called, it means a call to the abstract class has been made.
function abstract_class() {
    throw("AbstractClassInstantiationError: this class/object is declared as an abstract class and thus cannot be instantiated.");
}