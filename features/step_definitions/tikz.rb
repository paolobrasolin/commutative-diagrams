Given(/^I expect a node labeled "([^\"]*)" to exist$/) do |label|
  @job.document.append_to_body <<CODE
\\expandafter\\ifx\\csname pgf@sh@ns@#{label}\\endcsname\\relax\\FAIL\\else\\fi%
CODE
end

Given(/^I expect a node labeled "([^\"]*)" to not exist$/) do |label|
  @job.document.append_to_body <<CODE
\\expandafter\\ifx\\csname pgf@sh@ns@#{label}\\endcsname\\relax\\else\\FAIL\\fi%
CODE
end
