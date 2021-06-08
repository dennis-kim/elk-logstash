SELECT 
	mall_tp
    , keyword
    , SUM(cnt) cnt
    , SUM(all_cnt) all_cnt
FROM
(
        SELECT 
			keyword
            , sum(cnt*50) cnt
            , sum(cnt*50) all_cnt
            , CASE WHEN substring(disp_no,1,6)='001930'
                   THEN 'BOOK'
                   WHEN substring(disp_no,1,6)='001800'
                   THEN 'PET' ELSE 'SHOP'
			  END mall_tp
									FROM DMS.dms_naver_keyword_prd_sum
									WHERE char_length(trim(keyword)) < 61
									AND char_length(trim(keyword)) > 2
									GROUP BY mall_tp, keyword
									HAVING sum(cnt) >= 2
        UNION
        
        SELECT keyword, sum(cnt) cnt, sum(cnt) all_cnt,upper(mall_tp) mall_tp
						FROM DMS.dms_all_autocmpl_keyword
						WHERE mall_tp in ('shop','inter','book','pet')
						--AND time_key > date_add(curdate(), INTERVAL '-60' DAY)
						AND char_length(trim(keyword)) < 61
						AND char_length(trim(keyword)) > 2
						GROUP BY upper(mall_tp), keyword
						having sum(cnt) >= 20
) total
GROUP BY mall_tp, keyword