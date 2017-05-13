# Runs equation on a list and returns a list of results
def run_equation_on list, &block
    list.map do |i|
        block.call i
    end
end
