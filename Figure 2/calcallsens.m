data = readtable("1DSA_all_features_params.xlsx");
params = ["exp-expression-const","c-express-delay","d-express-delay","c-express-thresh","d-express-thresh","cluster-pause-delay","cluster-move-size","homotypic-prob","heterotypic-prob"];
data.Var = data.Var + "";
cols = data.Properties.VariableNames + "";
final_sens_data=["Var","Variation",cols(5:37)];
for i=1:length(params)
   cur_data = data(data.Var==params(i),1:end);
   cur_param_values = sort(unique(cur_data.Var_Value));
   data_1 = cur_data(cur_data.Var_Value == cur_param_values(1),1:end);
   data_2 = cur_data(cur_data.Var_Value == cur_param_values(2),1:end);
   data_3 = cur_data(cur_data.Var_Value == cur_param_values(3),1:end);
   len = min([height(data_1),height(data_2),height(data_3)]);
   
   data_1=table2array(data_1);
   data_2=table2array(data_2);
   data_3=table2array(data_3);
   
   div = (str2double(data_3(1:len,5:37)) - str2double(data_2(1:len,5:37))) / (cur_param_values(3) - cur_param_values(2));
   norm =  cur_param_values(2) ./ str2double(data_2(1:len,5:37));
   s_param_p10 = div .* norm;
   sens_app = [(repmat(params(i),len,1)),(repmat("p10",len,1)),s_param_p10];
   final_sens_data=[final_sens_data;sens_app];
       
   div = (str2double(data_1(1:len,5:37)) - str2double(data_1(1:len,5:37))) / (cur_param_values(1) - cur_param_values(2));
   norm =  cur_param_values(2) ./ str2double(data_2(1:len,5:37));
   s_param_m10 = div .* norm;
   sens_app = [(repmat(params(i),len,1)),(repmat("m10",len,1)),s_param_m10];
   final_sens_data=[final_sens_data;sens_app];
end
writematrix(final_sens_data, "1DSA_all_features_param_sensALL.xlsx");