function [out, buf] = brainfuck(code)
%BRAINFUCK A simple brainfuck interpreter.

out = '';
buf = 0;
buf_index = 1;
code_index = 1;

code(~ismember(code, '+-<>[],.')) = [];
match_table = build_match_table(code);

while code_index <= length(code)
    switch code(code_index)
    case '.'
        out(end+1) = buf(buf_index); %#ok<*AGROW>
    case ','
        buf(buf_index) = input('Input 1 character: ', 's');
    case '+'
        buf(buf_index) = buf(buf_index) + 1;
    case '-'
        buf(buf_index) = buf(buf_index) - 1;
    case '<'
        buf_index = buf_index - 1;
        if buf_index <= 0
            buf_index = 1;
            buf = [0 buf];
        end
    case '>'
        buf_index = buf_index + 1;
        if buf_index > length(buf)
            buf(end+1) = 0;
        end
    case '['
        if ~buf(buf_index)
            code_index = match_table(code_index);
        end
    case ']'
        if buf(buf_index)
            code_index = match_table(code_index);
        end
    end
    code_index = code_index + 1;
end

end

function match_table = build_match_table(code)
match_table = zeros(size(code));
stack_buf = [];
for i = 1 : length(code)
    if code(i) == '['
        stack_buf(end+1) = i;
    end
    if code(i) == ']'
        open_index = stack_buf(end);
        stack_buf(end) = [];
        match_table(open_index) = i;
        match_table(i) = open_index;
    end
end
end
