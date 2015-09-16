
# extract cross refences from reports in 'test_reports' FileList
def build_cross_refs( test_reports )

  xref_suite_X_test = {}
  xref_test_X_suite = {}
  
  # Iterate all test reports in 'generated-docs/suites'
  test_reports.each do |test_report_file|

    # puts "test_report_file=#{test_report_file}"
    
    # Extract suite_id from test file name
    # - generated-docs/suites/smoke.txt --> smoke
    # - generated-docs/suites/suite1-myInstance.txt --> suite1
    suite_id = File.basename(test_report_file)[ /([^.-]+)/,1]
    
    # Extract test name from lines with non-inteded single word 
    tests = File.readlines( test_report_file ).select{ |line|  line =~ /^\w\w*$/ }.map{ |line| line.strip }

    # Build cross refrences 

    # suite seen for the first time
    xref_suite_X_test[suite_id] = [] unless xref_suite_X_test[suite_id]
    tests.each{ |test| xref_suite_X_test[suite_id].push( test ) unless xref_suite_X_test[suite_id].include?( test ) }

    tests.each do  |test|
      # test seen for the first time
      xref_test_X_suite[test] = [] unless xref_test_X_suite[test]
      xref_test_X_suite[test].push( suite_id ) unless xref_test_X_suite[test].include?( suite_id )
    end

    # puts "suite_id = #{suite_id}, tests=#{tests}"

  end

  # Cross references resolved
  
  # puts "xref_suite_X_test=#{xref_suite_X_test}"
  # puts "xref_test_X_suite=#{xref_test_X_suite}"
  
  return xref_suite_X_test, xref_test_X_suite
  
end

# output graphviz 
def xref_to_dot( xref_suite_X_test, xref_test_X_suite )

  puts <<-EOS
          digraph {
             rankdir=TB
             
             // options for neato 
             // http://stackoverflow.com/questions/7670304/how-to-deal-with-densely-connected-graphs-with-neato
             overlap=false;
             splines=true;


             node      [     fontname = "Courier"
                             fontsize = 8
                             shape = "record"

             ];
             edge      [
                     fontname = "Bitstream Vera Sans"
                     fontsize = 8
                    // arrowhead = "none"
             ];
        EOS
  
  xref_test_X_suite.each do |test,suistes|
    puts "           #{test}"
  end

  xref_suite_X_test.each do  |suite,tests|
    puts "           #{suite} [shape=\"ellipse\"]"
    tests.each { |test| puts "           #{suite} -> #{test}" }

  end
  
  puts "}"


end
