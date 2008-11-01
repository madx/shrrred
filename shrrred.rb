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

  stack :margin => [10, 5, 5, 5] do
    background '#c8bad7'..'#762dc4'
    mask do
      subtitle "shrrred", :margin => 0
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
        @result = stack :margin => 5 do
          background "#ada"
          border "#494", :strokewidth => 5
          para code(README), :margin => 7, :font => 'normal 12px'
        end
      end
    end
  end

  def update_result
    debug Regexp.new(@regex.text)
  end

end
