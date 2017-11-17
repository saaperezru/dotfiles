import org.testng.AssertJUnit;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class MainTest {
    Main main = new Main();

    @DataProvider(name = "testData")
    public Object[][] testData() {
        return new Object[][] {
            { "Cedric", "Cedric" },
            { "Anne", "Anne" },
        };
    }

    @Test(dataProvider = "testData")
    public void test(String input1, String output) {
        AssertJUnit.assertEquals(output,main.test(input1));
    }
}
