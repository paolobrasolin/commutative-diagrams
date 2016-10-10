Transform(/^'(.*)'$/) do |quoted_string|
  quoted_string
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

Given(/^I input "([^\"]*)" to katharizo$/) do |code|
  @job.document.append_to_body <<CODE
\\pgfqkeys{/katharizo}{input={#{}}}
CODE
end
