import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;


import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;

import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;


public class TestCon {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		POIFSFileSystem fs = null;
		Document document = new Document();

		try {
			System.out.println("Starting the test");
			fs = new POIFSFileSystem(new FileInputStream("D:/Resume.doc"));

			HWPFDocument doc = new HWPFDocument(fs);
			WordExtractor we = new WordExtractor(doc);

			OutputStream file = new FileOutputStream(new File("D:/test.pdf"));

			PdfWriter writer = PdfWriter.getInstance(document, file);

			Range range = doc.getRange();
			document.open();
			writer.setPageEmpty(true);
			document.newPage();
			writer.setPageEmpty(true);

			String[] paragraphs = we.getParagraphText();
			for (int i = 0; i < paragraphs.length; i++) {

				org.apache.poi.hwpf.usermodel.Paragraph pr = range.getParagraph(i);
				// CharacterRun run = pr.getCharacterRun(i);
				// run.setBold(true);
				// run.setCapitalized(true);
				// run.setItalic(true);
				 paragraphs[i] = paragraphs[i].replaceAll("\\cM?\r?\n", "");
			System.out.println("Length:" + paragraphs[i].length());
			System.out.println("Paragraph" + i + ": " + paragraphs[i].toString());

			 // add the paragraph to the document
			document.add(new Paragraph(paragraphs[i]));
			}

			System.out.println("Document testing completed");
		}
		catch (Exception e) {
			 System.out.println("Exception during test");
			 e.printStackTrace();
		}
		finally {
						 // close the document
			document.close();
		}
	}
}