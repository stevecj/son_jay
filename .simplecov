proj_root = File.dirname(__FILE__)
SimpleCov.start do
  root File.join( proj_root, 'lib' )
  coverage_dir File.join( proj_root, 'coverage' )
end
