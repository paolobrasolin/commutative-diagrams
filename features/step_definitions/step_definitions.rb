# -*- coding: utf-8 -*-

require 'pathname'
require 'tmpdir'

Around do |scenario, block|
  @job = TeXWorld::Job.new
  dir = Pathname.new(Dir.mktmpdir('commutative-diagrams-'))
  @job.path = dir.join('main.tex')
  block.call
  dir.rmtree
end

Given(/^I'm using any TeX flavour$/) do
  @job.load(ENV.fetch('FLAVOUR'))
end

Given(/^I have a (.*) document$/) do |flavour|
  @job.load(flavour)
end

When(/^I use "([^\"]*)"$/) do |name|
  @job.document.idiom_use(binding)
end

When(/^the (preamble|body) is$/) do |part, sourcecode|
  # MEMO: the replacement is useful when interpolating
  #   from tables using trailing/leading spaces.
  @job.document.set_content(part, sourcecode.gsub(/«(.*?)»/, '\1'))
end

When(/^the (preamble|body) is empty$/) do |part|
  @job.document.set_content(part, '')
end

# When(/^the (preamble|body) contains$/) do |part, sourcecode|
#   # MEMO: the replacement is useful when interpolating
#   #   from tables using trailing/leading spaces.
#   @job.document.append_to(part, sourcecode.gsub(/«(.*?)»/, '\1'))
# end

When(/^I code ([^\"]*)$/) do |sourcecode|
  sourcecode.gsub!(/«(.*?)»/, '\1')
  @job.document.append_to('body', sourcecode)
end

When(/^I use the "([^\"]*)" TikZ library$/) do |name|
  @job.document.append_to('preamble', "\\usetikzlibrary{#{name}}\n")
end

When(/^I(?:'m| am) inside a "([^\"]*)"(?: with options "(.*)")?$/) do |name, options|
  @job.document.idiom_inside(binding)
end

Then(/^compilation (succeeds|fails)$/) do |outcome|
  succeeded = @job.run
  case outcome
  when 'succeeds'
    puts @job.path.sub_ext('.log').read unless succeeded
    expect(succeeded).to be true
  when 'fails'
    expect(succeeded).to be false
  end
end

Given(/^I dump "([^\"]*)" as "([^\"]*)"$/) do |macro, field|
  @job.document.append_to 'body', <<~CODE
    \\kDDump{'#{field}': '#{macro}'}
  CODE
end

# Given(/^I dump the "([^\"]*)" as "([^\"]*)"$/) do |macro, field|
#   @job.document.append_to 'body', <<~CODE
#     \\kDDump{'#{field}': '\\the#{macro}'}
#   CODE
# end

# Given(/^I dump the meaning of "([^\"]*)" as "([^\"]*)"$/) do |macro, field|
#   @job.document.append_to 'body', <<~CODE
#     \\kDDump{'#{field}': '\\meaning#{macro}'}
#   CODE
# end

# Given(/^the dumped value of "([^\"]*)" is "([^\"]*)"$/) do |field, value|
#   dump = YAML.load_file(@job.path.sub_ext('.yml').to_s)
#   expect(dump[field]).to eq(value)
# end

Given(/^the dumped «(.*)» is «(.*)»$/) do |field, value|
  dump = YAML.load_file(@job.path.sub_ext('.yml').to_s)
  expect(dump[field]).to eq(value)
end

# Given(/^the dumped "([^\"]*)" of "([^\"]*)" is "([^\"]*)"$/) do |field, item, value|
#   dump = YAML.load_file(@job.path.sub_ext('.yml').to_s)
#   expect(dump[item][field]).to eq(value)
# end

# TODO: there is a bug here: kdDumpOpen eats the first token and uses it
#   as filename; the escaped \  is just a quick hack.
Given(/^I want a debugging dump$/) do
  @job.document.wrap_body <<~'OPEN', <<~'CLOSE'
    \kDDumpingtrue
    \kDDumpOpen\
  OPEN
    \kDDumpClose
  CLOSE
end

Then(%r%^the log matches (.*)$%) do |regexp_string|
  log = @job.path.sub_ext('.log').read
  regexp = Regexp.new(regexp_string)
  expect(log).to match(regexp)
end

Then(%r%^the log includes (.*)$%) do |string|
  string.gsub!(/«(.*?)»/, '\1')
  log = @job.path.sub_ext('.log').read
  expect(log).to include(string)
end

Given(/^I expect a node labeled "([^\"]*)" to exist$/) do |label|
  @job.document.append_to 'body', <<~CODE
    \\expandafter\\ifx\\csname pgf@sh@ns@#{label}\\endcsname\\relax\\FAIL\\else\\fi%
  CODE
end

Given(/^I expect a node labeled "([^\"]*)" to not exist$/) do |label|
  @job.document.append_to 'body', <<~CODE
    \\expandafter\\ifx\\csname pgf@sh@ns@#{label}\\endcsname\\relax\\else\\FAIL\\fi%
  CODE
end

ParameterType(
  name: 'quoted',
  regexp: /«(.*)»/,
  transformer: -> (unquoted) { unquoted }
)
