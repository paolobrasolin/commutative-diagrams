# -*- coding: utf-8 -*-

Before do |_scenario|
  @job = TeXWorld::Job.new
  FileUtils.mkdir_p '.tex-test'
end

Given(/^I'm using any TeX flavour$/) do
  unless ENV.has_key?('DIALECT') && ENV.has_key?('PIPELINE')
    raise 'Both DIALECT and PIPELINE must be given through ENV.'
  end
  @job.document.load(ENV['DIALECT'])
  @job.pipeline.load(ENV['PIPELINE'])
end

When(/^I use "([^\"]*)"$/) do |name|
  macro = ERB.new(@job.document.idioms['use']).result(binding)
  @job.document.append_to('preamble', macro)
end

Given(/^I have a "([^\"]*)" document$/) do |template|
  @job.document.load(template)
end

Given(/^I(?:'m| am) compiling through "([^\"]*)"$/) do |pipeline|
  @job.pipeline.load(pipeline)
end

When(/^the (preamble|body) is$/) do |part, sourcecode|
  # MEMO: the replacement is useful when interpolating
  #   from tables using trailing/leading spaces.
  @job.document.content[part] = sourcecode.gsub(/«(.*?)»/, '\1')
end

When(/^the (preamble|body) is empty$/) do |part|
  @job.document.content[part] = ''
end

When(/^the (preamble|body) contains$/) do |part, sourcecode|
  # MEMO: the replacement is useful when interpolating
  #   from tables using trailing/leading spaces.
  @job.document.append_to(part, sourcecode.gsub(/«(.*?)»/, '\1'))
end

When(/^I code ([^\"]*)$/) do |sourcecode|
  @job.document.append_to('body', sourcecode)
end

When(/^I use the "([^\"]*)" TikZ library$/) do |name|
  @job.document.append_to('preamble', "\\usetikzlibrary{#{name}}\n")
end

When(/^I(?:'m| am) inside a "([^\"]*)"(?: with options "(.*)")?$/) do |name, options|
  before = ERB.new(@job.document.idioms['enclose']['before']).result(binding)
  after = ERB.new(@job.document.idioms['enclose']['after']).result(binding)
  @job.document.wrap_body(before, after)
end

Then(/^compilation (succeeds|fails)$/) do |outcome|
  # FileUtils.rm_f Dir.glob("#{path}/*")
  succeeded = @job.run
  case outcome
  when 'succeeds'
    puts File.read(".tex-test/#{@job.jobname}.log") unless succeeded
    expect(succeeded).to be true
  when 'fails'
    expect(succeeded).to be false
  end
end

After do |scenario|
end

Given(/^I dump "([^\"]*)" as "([^\"]*)"$/) do |macro, field|
  @job.document.append_to 'body', <<CODE
\\kDDump{'#{field}': '#{macro}'}
CODE
end

Given(/^I dump the "([^\"]*)" as "([^\"]*)"$/) do |macro, field|
  @job.document.append_to 'body', <<CODE
\\kDDump{'#{field}': '\\the#{macro}'}
CODE
end

Given(/^I dump the meaning of "([^\"]*)" as "([^\"]*)"$/) do |macro, field|
  @job.document.append_to 'body', <<CODE
\\kDDump{'#{field}': '\\meaning#{macro}'}
CODE
end

# Given(/^the dumped value of "([^\"]*)" is "([^\"]*)"$/) do |field, value|
#   dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
#   expect(dump[field]).to eq(value)
# end

Given(/^the dumped "([^\"]*)" is "([^\"]*)"$/) do |field, value|
  dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
  expect(dump[field]).to eq(value)
end

Given(/^the dumped "([^\"]*)" of "([^\"]*)" is "([^\"]*)"$/) do |field, item, value|
  dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
  expect(dump[item][field]).to eq(value)
end

# TODO: there is a bug here: kdDumpOpen eats the first token and uses it
#   as filename; the escaped \  is just a quick hack.
Given(/^I want a debugging dump$/) do
  @job.document.wrap_body <<'OPEN', <<'CLOSE'
\kDDumpingtrue
\kDDumpOpen\
OPEN
\kDDumpClose
CLOSE
end

Then(%r%^the log matches (.*)$%) do |regexp_string|
  log = File.read(".tex-test/#{@job.jobname}.log")
  regexp = Regexp.new(regexp_string)
  expect(log).to match(regexp)
end

Given(/^I expect a node labeled "([^\"]*)" to exist$/) do |label|
  @job.document.append_to 'body', <<CODE
\\expandafter\\ifx\\csname pgf@sh@ns@#{label}\\endcsname\\relax\\FAIL\\else\\fi%
CODE
end

Given(/^I expect a node labeled "([^\"]*)" to not exist$/) do |label|
  @job.document.append_to 'body', <<CODE
\\expandafter\\ifx\\csname pgf@sh@ns@#{label}\\endcsname\\relax\\else\\FAIL\\fi%
CODE
end

Transform(/^«(.*)»$/) do |unquoted|
  unquoted
end
