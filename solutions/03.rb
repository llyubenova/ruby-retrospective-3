module Graphics

  class Canvas
    attr_reader :canvas, :width, :height

    def initialize(width, height)
      @width = width
      @height = height
      @canvas = "-" * width * height
    end

    def set_pixel(x,y)
      @canvas[y * width + x] = '@' if pixel_in_canvas?(x,y)
    end

    def pixel_at?(x,y)
      @canvas[y * width + x] == '@' ? true : false
    end

    def pixel_in_canvas?(x,y)
      y * width + x < width * height ? true : false
    end

    def draw(figure)
      figure.rasterize.each {|point| set_pixel point.x, point.y}
    end

    def render_as(renderer)
      renderer.render self
    end
  end

  module Renderers

    module Ascii
      def self.render(canvas)
        canvas.canvas.chars.each_slice(canvas.width).map(&:join).join "\n"
      end
    end

    module Html
      def self.render(canvas)
        html = "<!DOCTYPE html>
  <html>
  <head>
    <title>Rendered Canvas</title>
    <style type=\"text/css\">
      .canvas {
        font-size: 1px;
        line-height: 1px;
      }
      .canvas * {
        display: inline-block;
        width: 10px;
        height: 10px;
        border-radius: 5px;
      }
      .canvas i {
        background-color: #eee;
      }
      .canvas b {
        background-color: #333;
      }
    </style>
  </head>
  <body>
    <div class=\"canvas\">"
        rendered = canvas.canvas.chars.each_slice(canvas.width).map(&:join).join "<br>"
        rendered.gsub!(/@/, "<b></b>")
        rendered.gsub!(/-/, "<i></i>")
        html << rendered
        html << "</div>
  </body>
  </html>"
      end
    end
  end

  class Point
    def initialize(x,y)
      @x = x
      @y = y
    end

    def x
      @x
    end

    def y
      @y
    end

    def ==(other)
      self.x == other.x and self.y == other.y
    end

    def eql?(other)
      self == other
    end

    def hash
      [x,y].hash
    end

    def rasterize
      pixels = [self]
    end
  end

  class Line
    def initialize(from,to)
      @from = from
      @to = to
    end

    def from
      if @from.x == @to.x
        @from.y <= @to.y ? @from : @to
      else
        @from.x < @to.x ? @from : @to
      end
    end

    def to
      if @from.x == @to.x
        @from.y >= @to.y ? @from : @to
      else
        @from.x > @to.x ? @from : @to
      end
    end

    def ==(other)
      self.from == other.from and self.to == other.to
    end

    def != (other)
      not self == other
    end

    def eql?(other)
      self == other
    end

    def hash
      [from.hash, to.hash].hash
    end

    def rasterize
      pixels = []
      steep = (to.y - from.y).abs > (to.x - from.x).abs
      if steep
        bresenham(from.y, from.x, to.y, to.x ,steep, pixels)
      else
        bresenham(from.x, from.y, to.x ,to.y, steep, pixels)
      end
      pixels
    end

  private
    def bresenham(from_x, from_y, to_x, to_y, steep, pixels)
      dx, dy = to_x - from_x, (to_y - from_y).abs
      error, step = dx / 2, to_y <=> from_y
      from_x.upto to_x do |x|
        steep ? (pixels.push Point.new from_y, x) : (pixels.push Point.new x, from_y)
        error -= dy
        from_y += step and error += dx if error < 0
      end
    end

  end

  class Rectangle
    def initialize(start_point, end_point)
      @start = start_point
      @end = end_point
    end

    def left
      Line.new(@start,@end).from
    end

    def right
      Line.new(@start,@end).to
    end

    def top_left
      y_coordinate = [left.y, right.y].min
      Point.new(left.x, y_coordinate)
    end

    def top_right
      y_coordinate = [left.y, right.y].min
      Point.new(right.x, y_coordinate)
    end

    def bottom_left
      y_coordinate = [left.y, right.y].max
      Point.new(left.x, y_coordinate)
    end

    def bottom_right
      y_coordinate = [left.y, right.y].max
      Point.new(right.x, y_coordinate)
    end

    def ==(other)
      self.top_left == other.top_left and self.bottom_right == other.bottom_right
    end

    def eql?(other)
      self == other
    end

    def hash
      [top_left, bottom_right].hash
    end

    def rasterize
      pixels = []
      pixels << Line.new(top_left,top_right).rasterize
      pixels << Line.new(top_left,bottom_left).rasterize
      pixels << Line.new(top_right,bottom_right).rasterize
      pixels << Line.new(bottom_left,bottom_right).rasterize
      pixels.flatten
    end
  end
end