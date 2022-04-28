/**
 * @description PDF 페이지 표시용 컨트롤러
 */
    public class CntrlDspPdf {

        // PDF 페이지 URL
        public String pdfPageUrl {get; set;}

        /**
         * @description 생성자
         */
        public CntrlDspPdf(){
            // PDF 페이지의 URL 습득
            // pdfPageUrl = Page.DspPdf.getUrl();
            pdfPageUrl = null;
        }
    }