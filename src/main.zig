const std = @import("std");
const sleep = std.time.sleep;
const print = std.debug.print;

const width: u32 = 50;
const height: u32 = 25;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

//const top = [1]u8{'#'} ** width;

pub fn main() !void {
    defer {
        _ = gpa.deinit();
    }
    //var field = try allocator.alloc([]u8, height);
    // var field: [height][width]u8 = undefined;
    // field[0] = "#" ** width;
    // for (1..field.len - 1) |i| {
    //     field[i] = @constCast("#" ++ " " ** (width - 2) ++ "#");
    // }
    // field[field.len - 1] = @constCast("#" ** width);

    //var snake = Snake{ .x = width / 2, .y = height / 2, .length = 1, .dead = false };
    var snake = Snake.init();

    while (true) {
        draw(&snake);

        if (snake.isDead()) {
            print("GAME OVER", .{});
            break;
        }
        sleep(500 * std.time.ns_per_ms);
    }
}

fn draw(snake: *Snake) void {
    clear();

    for (0..height) |i| {
        if (i == 0 or i == height - 1) {
            print("{s}\n", .{"#" ** width});
        } else {
            for (0..width) |j| {
                if (j == 0 or j == width - 1) {
                    print("#", .{});
                } else {
                    if (snake.x == j and snake.y == i) {
                        print("o", .{});
                    } else {
                        print(" ", .{});
                    }
                }
            }
            print("\n", .{});
        }
    }

    snake.update();
}

fn clear() void {
    print("\x1b[2J\x1b[H", .{});
}

const Snake = struct {
    x: usize,
    y: usize,
    length: u8,
    dead: bool,
    dir: Direction,

    pub fn init() Snake {
        return Snake{ .x = width / 2, .y = height / 2, .length = 1, .dead = false, .dir = Direction.down };
    }

    pub fn isDead(s: @This()) bool {
        return s.x <= 0 or s.x >= width - 1 or s.y <= 0 or s.y >= height - 1;
    }

    pub fn update(s: *@This()) void {
        switch (s.dir) {
            .up => s.y -= 1,
            .down => s.y += 1,
            .left => s.x -= 1,
            .right => s.x += 1,
        }
    }
};

const Direction = enum { up, down, left, right };
