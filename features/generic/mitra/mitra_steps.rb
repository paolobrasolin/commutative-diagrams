When(/^the dump gives "([^\"]*)" and "([^\"]*)" for cells$/) do |options, content, table|
  dump = YAML.load_file(".tex-test/#{@job.jobname}.yml")
  data = table.raw[1..-1].map { |r| r.join('-') }
  data.each do |item|
    expect(dump[item]['options']).to eq(options)
    expect(dump[item]['content']).to eq(content)
  end
end

