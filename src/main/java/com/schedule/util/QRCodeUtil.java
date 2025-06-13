package com.schedule.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.Result;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 二维码工具类
 */
public class QRCodeUtil {
    
    private static final int WIDTH = 300;
    private static final int HEIGHT = 300;
    
    /**
     * 生成二维码图片字节数组
     * 
     * @param content 二维码内容
     * @return 图片字节数组
     */
    public static byte[] generateQRCode(String content) throws WriterException, IOException {
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.M);
        hints.put(EncodeHintType.MARGIN, 1);
        
        BitMatrix bitMatrix = new MultiFormatWriter().encode(content, BarcodeFormat.QR_CODE, WIDTH, HEIGHT, hints);
        BufferedImage image = MatrixToImageWriter.toBufferedImage(bitMatrix);
        
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        ImageIO.write(image, "PNG", outputStream);
        return outputStream.toByteArray();
    }
    
    /**
     * 解析二维码图片
     * 
     * @param image 二维码图片
     * @return 解析出的文本内容
     */
    public static String decodeQRCode(BufferedImage image) throws Exception {
        BufferedImageLuminanceSource source = new BufferedImageLuminanceSource(image);
        HybridBinarizer binarizer = new HybridBinarizer(source);
        
        Result result = new MultiFormatReader().decode(new com.google.zxing.BinaryBitmap(binarizer));
        return result.getText();
    }
}