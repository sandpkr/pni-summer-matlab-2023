%%% week_1_lecture_2 code
clear
clc

character_example='Hello world';
number_example_1=5;
number_example_2=2.718;

%% example of a collection of numbers
array_example_numbers=[1,2,3];


%% example of a collection of strings
array_example_chars{1}='Hello';
array_example_chars{2}='World';
%% example of collection of a number and string 
number_and_string_array{1,1}=2;
number_and_string_array{1,2}='text';

%% making an array
row_vector=[11 12 13 14 15 16];
column_vector=[24;25;26;27];
scalar_example=[2];
matrix_example=[31 32 33; 34 35 36];

big_mat_eg=[1 2 3 4; 5 6 7 8; 9 10 11 12];
%% learning more about the matrices
new_matrix=[1 2 3 4; 5 6 7 8]
length(new_matrix)
new_matrix(5)
size(new_matrix)

%% 3 dim matrix example
three_dim_mat(:,:,1)=[1 2 3; 4 5 6];
three_dim_mat(:,:,2)=[11 12 13; 14 15 16];
three_dim_mat(:,:,3)=[21 22 23; 24 25 26];

%% Defining matrices in matlab
vector_1=[2:7]
vector_2=[5:5:30]
only_odd_numbers=[1:2:13]
descending_even_numbers=[14:-2:2]

%% defining matrices in matlab using in-built functions
matrix_name=linspace(start_num, end_num, num_elements)

clc
ones(2,3)

%% generate matrix with random numbers
random_matrix=rand(2,3)
random_matrix_with_integers=randi(9,2,3) %%% randi(max_integer,num_row, num_col
normal_distribution_array=randn(10,1)

zeros(3,3)
nan(2,4)

%%
