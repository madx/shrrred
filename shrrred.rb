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

  stack :margin => [10, 5, 5, 0] do
    background '#c8bad7'..'#762dc4'
    mask do
      flow do
        subtitle "shrrred", :margin => 0
        para "a Ruby regular expression editor", :margin_top => 16
        button("Quit", :right => 10, :margin_top => 5) { quit }
      end
    end
  end

  stack :margin => [10, 0, 10, 10], :height => 0.87 do
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
        para link("Reference", :click => proc {help}),
             :margin => [10, 5, 10, 5]
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
              formatted = [strong("Match: "), code(res[0])]
              res[1..-1].each_with_index do |capture, i|
                formatted << code("\n#{i+1}: #{capture}")
             end
             res = formatted
            end
            background '#222'
            if res.nil?
              para "No matches", :stroke => '#efefef', :font => 'normal 12px'
            else
              para res, :stroke => '#efefef', :font => 'normal 12px'
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

  def help
    window :width => 600, :height => 400 do
      style Shoes::Para, :font => "12px", :margin => 0
      style Shoes::Code, :font => "bold"
      style Shoes::Subtitle, :font => 'bold'

      background "#111".."#333", :height => 0.1
      background "#333", :top => 0.1, :height => 0.9

      stack :margin => [10, 5, 5, 0] do
        background '#c8bad7'..'#762dc4'
        mask do
          flow do
            subtitle "shrrred", :margin => 0
            para "regexp reference", :margin_top => 16, :font => "bold 16px"
            button("Close", :right => 10, :margin_top => 5) { close }
          end
        end
      end
      stack :margin => [10, 0, 10, 10], :height => 0.87 do
        background "#eee", :curve => 12
        flow :margin => [10, 0, 10, 5] do
          stack :width => 0.5 do
            para code("[abc]"), ": any single character among a, b, and c\n",
              code("[^abc]"), ": any single character BUT a, b or c\n",
              code("[a-z]"), ": any character in range a-z\n",
              code("[a-zA-Z]"), ": any character in range a-z o A-Z\n",
              code("."),  ": any character except newline (unless mode m)",
              code("a*"),  ": 0 or more of a\n",
              code("a+"),  ": 1 or more of a\n",
              code("a?"),  ": 0 or 1 of a\n",
              code("(...)"), ": capture everything enclosed\n",
              code("(a|b)"), ": a or b\n",
              code("a{3}"), ": exactly 3 of a\n",
              code("a{3,}"), ": 3 or more of a\n",
              code("a{3,5}"), ": between 3 and 5 of a\n"
          end
          stack :width => 0.5 do
            para code("^"), ": start of line\n",
              code("$"), ": end of line\n",
              code("\\A"), ": start of string\n",
              code("\\z"), ": end of string\n",
              code("\\s"), ": any whitespace character\n",
              code("\\S"), ": any non-whitespace character\n",
              code("\\d"), ": any digit\n",
              code("\\D"), ": any non-digit\n",
              code("\\w"), ": any word character\n",
              code("\\W"), ": any non-word character\n",
              code("\\b"), ": any word boundary character\n"
          end
        end
      end
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
