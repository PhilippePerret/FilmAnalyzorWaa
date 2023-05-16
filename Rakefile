require "minitest/test_task"

Minitest::TestTask.create # named test, sensible defaults

# or more explicitly:

Minitest::TestTask.create(:test) do |t|
  t.libs << "tests"
  t.libs << "lib"
  t.warning = false
  # t.test_globs = ["tests/**/*_test.rb"]
  t.test_globs = ["tests/tests/pfa_test.rb"]
end

task :default => :test
