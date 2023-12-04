
grid_size = 8;
square_size = 200 / grid_size;

layout = [
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 0, 1, 0, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 1, 1],
    [1, 0, 0, 0, 1, 1, 1, 1],
    [1, 0, 0, 0, 1, 1, 1, 1],
    [1, 0, 1, 1, 1, 0, 0, 1],
    [1, 0, 0, 1, 1, 1, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1]
];

for( i = [0 : grid_size - 1] )
{
    for( ii = [0 : grid_size - 1] )
    {
        translate([i * square_size, -(ii+1) * square_size, 0])
        if( layout[ii][i])
        square(square_size);
    }
}