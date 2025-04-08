<?php
use PHPUnit\Framework\TestCase;
use Demo\File19;

class File19Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File19::add(2, 3));
    }
}
