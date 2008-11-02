#!/usr/bin/env shoes

README = <<END
Shrrred is a Ruby regular expression tester inspired from Rubular.
To start, enter a regex and a test string.
END

Shoes.app :width => 600, :height => 400, :title => "shrrred" do
  style Shoes::Para,     :font => 'bold'
  style Shoes::Subtitle, :font => 'bold'

  background "#111".."#333", :height => 0.1
  background "#333", :top => 0.1, :height => 0.9

  def readme
    @result.clear do
      background '#ada'
      border '#494', :strokewidth => 5
      para code(README), :margin => 7, :font => 'normal 12px'
    end
  end

  stack :margin => [10, 5, 5, 5] do
    background '#c8bad7'..'#762dc4'
    mask do
      flow do
        subtitle "shrrred", :margin => 0
        para "a regular expression editor", :margin_top => 16
      end
    end
  end

  stack :margin => [10, 5, 10, 10], :height => 0.8725 do
    background "#eee", :curve => 12
    

    flow :margin => [10, 0, 10, 5] do
      para "Regular expression: \n", :margin => 5
      flow :margin_top => 5 do
        title "/ ", :font => 'bold 16px'
        @regex = edit_line :width => 475, :change => proc { update_result }
        title "/ ", :font => 'bold 16px'
        @modifier = edit_line :width => 50, :change => proc { update_result }
      end
    end

    flow :margin => [10, 0, 10, 5] do
      stack :width => 0.5 do
        para "Test string:", :margin => 5
        @string = edit_box :width => 1.0, :margin => [10, 5, 10, 5],
                           :change => proc { update_result }
      end
      stack :width => 0.5 do
        para "Result:", :margin => 5
        @result = stack :margin => 5
      end
    end
    readme
  end

  def update_result
    unless @string.text.empty?
      unless @regex.text.empty?
        mod = parse_modifiers(@modifier.text)
        @result.clear do
          begin
            Regexp.new(@regex.text, mod) =~ @string.text
            res = if $~.nil? then nil else $~.dup end
            unless res.nil?
              formatted = "Match: #{res[0]}"
              res[1..-1].each_with_index do |capture, i|
                formatted += "\n#{i+1}: #{capture}"
             end
             res = formatted
            end
            background '#222'
            if res.nil?
              para "No matches", :stroke => '#efefef', :font => 'normal 12px'
            else
              para code(res), :stroke => '#efefef', :font => 'normal 12px'
            end
          rescue => e
            @result.clear do
              background '#daa'
              border '#944', :strokewidth => 5
              para e.class, "\n", code(e), :margin => 7
            end
          end
        end
      else
        readme
      end
    else
      readme
    end
  end

  def parse_modifiers(str)
    mod = 0
    opts = {
      'i' => Regexp::IGNORECASE,
      'x' => Regexp::EXTENDED,
      'm' => Regexp::MULTILINE
    }
    chars = str.split('')
    for c in chars
      if opts.keys.include? c
        mod |= opts[c]
      end
    end
    mod
  end

end
