require 'yaml'

Transform(/^'(.*)'$/) do |quoted_string|
  quoted_string
end

Given(/^the dumped "([^\"]*)" is "([^\"]*)"$/) do |field, value|
  dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
  expect(dump[field]).to eq(value)
end

Given(/^I detokenize "([^\"]*)"$/) do |code|
  @job.document.append_to_body <<CODE
\\kDDetokenize{#{code}}\\kDInto DETOKENIZED\\kDRelax
\\newwrite\\file
\\immediate\\openout\\file=\\jobname.yml
\\immediate\\write\\file{detokenized: '\\DETOKENIZED'}
\\closeout\\file
CODE
end

Given(/^I sanitize "([^\"]*)"$/) do |code|
  @job.document.append_to_body <<CODE
\\kDSanitize{#{code}}\\kDInto SANITIZED\\kDRelax
\\newwrite\\file
\\immediate\\openout\\file=\\jobname.yml
\\immediate\\write\\file{sanitized: '\\SANITIZED'}
\\closeout\\file
CODE
end

# Given(/^I sanitize "([^\"]*)"$/) do |code|
  # @job.document.append_to_body <<CODE
# \\pgfqkeys{/katharizo}{input={#{code}}}
# CODE
# end

Given(/^I dump "([^\"]*)" as "([^\"]*)"$/) do |macro, field|
  @job.document.append_to_body <<CODE
\\immediate\\write\\file{#{field}: '#{macro}'}
CODE
end

Given(/^I want a debugging dump$/) do
  @job.document.wrap_body <<'OPEN', <<'CLOSE'
\newwrite\file
\immediate\openout\file=\jobname.yml
OPEN
\closeout\file
CLOSE
end

