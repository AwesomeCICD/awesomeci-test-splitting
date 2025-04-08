<?php
use PHPUnit\Framework\TestCase;
use Demo\File68;

class File68Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File68::add(2, 3));
    }
}
