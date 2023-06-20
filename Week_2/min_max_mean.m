function output=min_max_mean(input_array)

  fah_temp=min(input_array);
  max_value=max(input_array);
  mean_value=mean(input_array);

  output=[fah_temp, max_value, mean_value];

end