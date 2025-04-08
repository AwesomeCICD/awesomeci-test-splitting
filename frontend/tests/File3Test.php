<?php
use PHPUnit\Framework\TestCase;
use Demo\File3;

class File3Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File3::add(2, 3));
    }
}
