--Chuyển đổi kiểu dữ liệu phù hợp cho từng trường

alter table public.sales_dataset_rfm_prj 
alter column ordernumber type int using (trim(ordernumber)::int);
alter table public.sales_dataset_rfm_prj 
alter column quantityordered type smallint using (trim(quantityordered)::smallint);
alter table public.sales_dataset_rfm_prj 
alter column priceeach type money using (trim(priceeach)::money);
alter table public.sales_dataset_rfm_prj 
alter column orderlinenumber type smallint using (trim(orderlinenumber)::smallint);
alter table public.sales_dataset_rfm_prj 
alter column sales type money using (trim(sales)::money);
ALTER TABLE public.sales_dataset_rfm_prj ADD COLUMN create_time_holder TIMESTAMP without time zone NULL;
UPDATE public.sales_dataset_rfm_prj SET create_time_holder = orderdate::TIMESTAMP;
ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN orderdate TYPE TIMESTAMP without time zone USING create_time_holder;
ALTER TABLE public.sales_dataset_rfm_prj DROP COLUMN create_time_holder;
 --------------------------------------------------------

--Check null / blank
select *
from public.sales_dataset_rfm_prj
where ORDERNUMBER is NULL

select *
from public.sales_dataset_rfm_prj
where QUANTITYORDERED is NULL

select *
from public.sales_dataset_rfm_prj
where PRICEEACH is NULL;

select *
from public.sales_dataset_rfm_prj
where  ORDERLINENUMBER is NULL;

select *
from public.sales_dataset_rfm_prj
where SALES is NULL;

select *
from public.sales_dataset_rfm_prj
where ORDERDATE is NULL;
---------------------------------------------------------

-- tạo cột first name và last name từ full name

ALTER TABLE public.sales_dataset_rfm_prj ADD COLUMN CONTACTFIRSTNAME Varchar;
UPDATE sales_dataset_rfm_prj AS ctf
SET CONTACTFIRSTNAME =  substring(ctf.CONTACTFULLNAME,1,position('-' in ctf.CONTACTFULLNAME )-1) ;

ALTER TABLE public.sales_dataset_rfm_prj ADD COLUMN CONTACTLASTNAME Varchar;
UPDATE sales_dataset_rfm_prj AS ctl
SET CONTACTLASTNAME = substring(ctl.CONTACTFULLNAME, position('-' in ctl.CONTACTFULLNAME )+1);

----------------------------------------------------------

--Chuyển đổi chữ cái đầu tiên thành chữ viết hoa
UPDATE sales_dataset_rfm_prj AS ctl
SET CONTACTLASTNAME = upper(substring(ctl.contactlastname,1,1)) || substring(ctl.contactlastname,2)
UPDATE sales_dataset_rfm_prj AS ctf
SET CONTACTfirstNAME = upper(substring(ctf.contactfirstname,1,1)) || substring(ctf.contactfirstname,2)

----------------------------------------------------------

--Tạo 3 cột tháng năm và quý 
ALTER TABLE public.sales_dataset_rfm_prj ADD COLUMN MONTH_ID numeric ;
UPDATE sales_dataset_rfm_prj AS sl
SET MONTH_ID = extract(month from sl.orderdate) from public.sales_dataset_rfm_prj

ALTER TABLE public.sales_dataset_rfm_prj ADD COLUMN YEAR_ID numeric ;
UPDATE sales_dataset_rfm_prj AS slt
SET YEAR_ID = extract(year from slt.orderdate) from public.sales_dataset_rfm_prj

ALTER TABLE public.sales_dataset_rfm_prj ADD COLUMN QTR_ID numeric ;
UPDATE sales_dataset_rfm_prj AS sls
SET QTR_ID = case
when extract(month from sls.orderdate) >=1 and extract(month from sls.orderdate) <=3 then 1
when extract(month from sls.orderdate) >3 and extract(month from sls.orderdate) <=6 then 2
when extract(month from sls.orderdate) >6 and extract(month from sls.orderdate) <=9 then 3
when extract(month from sls.orderdate) >9 and extract(month from sls.orderdate) <=12 then 4
end
------------------------------------------------------

--tìm outliers
with cte as (
select q1-1.5*iqr as min_vl,
q3+1.5*iqr as max_vl
from (
select 
percentile_cont(0.25) within group (order by quantityordered) as q1,
percentile_cont(0.5) within group (order by quantityordered) as q2,
percentile_cont(0.75) within group (order by quantityordered) as q3,
percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered) as iqr
from public.sales_dataset_rfm_prj) as pct
)

select quantityordered from public.sales_dataset_rfm_prj
where quantityordered < (select min_vl from cte)
or quantityordered > (select max_vl from cte)


