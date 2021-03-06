class Task

  def initialize(task_as_array = [])
    @status, @description, @priority, @tags = task_as_array
  end

  def status
    @status.downcase.intern
  end

  def description
    @description
  end

  def priority
    @priority.downcase.intern
  end

  def tags
    @tags.split(", ")
  end

end


class TodoList
  include Enumerable

  attr_reader :tasks

  def initialize(tasks_array)
    @tasks = tasks_array
  end

  def self.parse(text)
    TodoList.new text.lines.map {|line| Task.new(line.split("|").map(&:strip))}
  end

  def each
    @tasks.each {|task| yield task}
  end

  def filter(criteria)
    TodoList.new tasks.select {|task| criteria.match? task}
  end

  def adjoin(other)
    TodoList.new self.tasks | other.tasks
  end

  def tasks_todo
    self.select {|task| task.status == :todo}.size
  end

  def tasks_in_progress
    self.select {|task| task.status == :current}.size
  end

  def tasks_completed
    self.select {|task| task.status == :done}.size
  end

  def completed?
    self.all? {|task| task.status == :done}
  end

end


class Criteria

  class << self
    def status(criterion)
      Criterion.new {|task| task.status == criterion}
    end

    def priority(criterion)
      Criterion.new {|task| task.priority == criterion}
    end

    def tags(criterion)
      Criterion.new {|task| (criterion - task.tags).size == 0}
    end
  end
end

class Criterion

  def initialize(&condition)
    @condition = condition
  end

  def match?(task)
    @condition.call task
  end

  def &(other)
    Criterion.new {|task| match?(task) and other.match?(task)}
  end

  def |(other)
    Criterion.new {|task| match?(task) or other.match?(task)}
  end

  def !
    Criterion.new {|task| not match?(task)}
  end
end