module Asm
  class Instruction
    attr_accessor :memory

    def initialize
      @memory = {ax: 0, bx: 0, cx: 0, dx: 0}
    end

    def method_missing(name, *args)
      case name
        when :ax then :ax
        when :bx then :bx
        when :cx then :cx
        when :dx then :dx
      end
    end

    def mov (destination_register, source)
      evaluate(:mov, destination_register, source)
    end

    def inc (destination_register, value = 1)
      evaluate(:inc, destination_register, value)
    end

    def dec (destination_register, value = 1)
      evaluate(:dec, destination_register, value)
    end

    def cmp (register, value)
      evaluate(:cmp, register, value)
    end

    def evaluate(instruction_name, register, value)
      value = @memory[value] unless value.is_a? Integer
      case instruction_name
        when :mov then @memory[register] = value
        when :inc then @memory[register] += value
        when :dec then @memory[register] -= value
        when :cmp then  @memory[register] <=> value
      end
      @memory.values
    end
  end

  def self.asm(&block)
    Instruction.new.instance_eval &block
  end
end