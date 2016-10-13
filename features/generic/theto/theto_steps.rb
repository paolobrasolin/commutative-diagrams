# Transform /^"([^\"]*)"$/ do |unquoted_string|
  # unquoted_string
# end

Transform /^«(.*)»$/ do |argument|
  argument
end

When(/^the dump gives "([^\"]*)" and "([^\"]*)" for cells$/) do |options, content, table|
  dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
  data = table.raw[1..-1].map { |r| r.join('-') }
  data.each do |item|
    expect(dump[item]['options']).to eq(options)
    expect(dump[item]['content']).to eq(content)
  end
end

Given(/^the dumped "([^\"]*)" is "([^\"]*)"$/) do |field, value|
  dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
  expect(dump[field]).to eq(value)
end

Given(/^the dumped "([^\"]*)" of "([^\"]*)" is "([^\"]*)"$/) do |field, item, value|
  dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
  expect(dump[item][field]).to eq(value)
end


