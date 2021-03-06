require 'bigdecimal'
require_relative 'lib/red-test'

ZERO = BigDecimal 0
ONE = BigDecimal 1
TWO = BigDecimal 2
TEN = BigDecimal 10
MINUS_ONE = BigDecimal -1
MIN_COEFFICIENT = ZERO
MAX_COEFFICIENT = BigDecimal 0x00FFFFFFFFFFFFFF
MIN_EXPONENT = BigDecimal -127
MAX_EXPONENT = BigDecimal 127
MIN = MAX_COEFFICIENT * (TEN ** MIN_EXPONENT)
MAX = MAX_COEFFICIENT * (TEN ** MAX_EXPONENT)
NUM_SAMPLES = 10
single_values = [MIN, ZERO, ONE, TWO, MINUS_ONE, MAX]
srand 1
NUM_SAMPLES.times { |i| single_values << BigDecimal(rand(MAX)) }
NUM_SAMPLES.times { |i| single_values << BigDecimal(-rand(MAX)) }
test_pairs = single_values.permutation(2).to_a

includes = [
    '#include %../../,,/quick-test/quick-test.red'
]

gen_test = lambda do |context, x, y| 
    z = context.calc_expected x, y
    test = context.generate_test_name +
           context.set_word('x', x, :to_red_money) +
           context.set_word('y', y, :to_red_money) +
           context.set_word('z', z, :to_red_money) +
           "\t\t" + '--assert z  = (x ' + context.red_fn + ' y)' + "\n\n"
end

gen_comp_test = lambda do |context, x, y|
    z = context.calc_expected x, y
    context.generate_test_name +
    context.set_word('x', x, :to_red_money) +
    context.set_word('y', y, :to_red_money) +
    context.set_word('z', z) +
    "\t\t" + '--assert z  =  (x ' + context.red_fn + ' y)' + "\n\n"
end

red_operators = [
    RedFunc2Params.new('add', '+', :+.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('subtract', '-', :-.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('multiply', '*', :*.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('divide', '/', :/.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('lesser or equal', '<=', :<=.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('lesser', '<', :<.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('equal', '=', :==.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('not equal', '<>', :!=.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('greater', '>', :>.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('greater or equal', '>=', :>=.to_proc, gen_comp_test, test_pairs)
]

puts RedTest.start_file "money-generated", includes
red_operators.each { |red_op| puts red_op.generate_test_group }
puts RedTest.end_file
