<?php
use PHPUnit\Framework\TestCase;
use Demo\File83;

class File83Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File83::add(2, 3));
    }
}
