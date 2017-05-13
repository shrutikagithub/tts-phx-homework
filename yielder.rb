# Sample usage:
# ---
# assert 1, 1 {|expected, actual, result| puts "Expected: #{expected}, Got: #{actual}" if !result}
def assert_eq expected, actual
    result = expected == actual
    yield expected, actual, result
    return result
end

assert_eq(1, 1) {|expected, actual, result| puts "[Passed] Expected: #{expected}, Got: #{actual}" if result}
assert_eq(1, 2) {|expected, actual, result| puts "[Failed] Expected: #{expected}, Got: #{actual}" if !result}

# Yielder takes a timeout value and a block as arguments
# ---
# Arguments:
#  timeout - time in seconds to run before timing out
#  &block  - any valid ruby block to call
# ---
# Conditions:
#  1. If the block yields before the timeout occurs, the result of the block is yielded and returned
#  2. If the block does not yield before the timeout occurs, the result YIELD_TIMEOUT_ERR is yielded and returned
def yielder timeout, &block
    counter = 0
    result = nil
    thread = Thread.new { result = block.call }
    until counter == timeout
        # Return the result if the block is finished
        return result if result

        # Otherwise increase the counter and sleep if no result returned yet
        counter += 1
        sleep 1
    end

    # If timeout occurred, return YIELD_TIMEOUT_ERR
    return "YIELD_TIMEOUT_ERR"
end

# test_block = Proc.new {|n| sleep(15); return "PASSED"}
test1 = yielder(2) {sleep(3); "PASSED"}
assert_eq("YIELD_TIMEOUT_ERR", test1) {|e, a, r| puts "[#{r ? 'Passed' : 'Failed'}] Expected: #{e}, Got: #{a}"}

test2 = yielder(5) {sleep(3); "PASSED"}
assert_eq("PASSED", test2) {|e, a, r| puts "[#{r ? 'Passed' : 'Failed'}] Expected: #{e}, Got: #{a}"}