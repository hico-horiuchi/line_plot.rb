#!/usr/bin/ruby

if ARGV.empty?
  puts "usage: ./line_plot.rb TITLE X_LABEL Y_LABEL FILE [FILE]..."
  exit
end

ENV['BUNDLE_GEMFILE'] = File.expand_path(File.join(File.dirname($0), "Gemfile"))

require 'bundler'
Bundler.require

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.term "postscript 16 color"
    plot.output ARGV.first + ".eps"
    plot.title ARGV.shift
    plot.xlabel ARGV.shift
    plot.ylabel ARGV.shift

    ARGV.each do |file|
      y = []
      File.open(file).each_line do |line|
        y << line.to_f
      end
      x = (0..y.size - 1).collect {|v| v.to_i}
      plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
        ds.with = "lines"
        ds.linewidth = 4
        ds.title = file
      end
    end

    plot.grid
  end
end
